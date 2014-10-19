require 'stylus'
require 'uglifier'

module JekyllAssetBundle
  class Pipeline
    
    class << self  
      def run(asset_name, type, site)
        @site = site

        cache_key = type + '_' + asset_name
        if cache.has_key?(cache_key)            
          return cache[cache_key], true
        else
          puts "Processing #{type} #{asset_name}"
          pipeline = self.new(asset_name, type, site)
          cache[cache_key] = pipeline
        end
      end
      
      def cache
        @cache ||= {}
      end
    
      def clear_cache
        @cache = {}
      end     
      
      def remove_staged_assets
        FileUtils.rm_rf(File.join(@site.source, DEFAULTS[:staging]))
      end 
    end
    
    def initialize(asset_name, type, site)
      @name = asset_name 
      @type = type # e.g. js
      @site = site        
      @source = File.join(DEFAULTS[:source], type) # e.g. /_assets/js
      @dest = File.join(DEFAULTS[:dest], type) # e.g. /assets/js
      process
    end
    
    attr_reader :assets, :html
    
    private
    def process  
      collect 
      if @type == 'css'
        Stylus.paths << '.' + @source         
        convert(Jekyll::ENV != 'development')
      end
      
      if Jekyll::ENV != 'development'
        bundle 
        compress if @type == 'js'
      end
      save
      markup
    end
    
    def collect
      @assets = []
      
      base = File.join(@site.source, @source, @name)
      # look for a file with this name
      file = Dir[base+'.*'][0]
      ext = File.extname(file)
      if ext == '.yml'
        @assets = YAML::load(File.open(file)).map! do |path|          
          File.open(File.join(@site.source, @source, path + ".#{@type}")) do |file|
            Asset.new(file.read, path + ".#{@type}")
          end
        end
      elsif ext == '.styl'                              
        @assets = [File.open(file){|file| Asset.new(file.read, File.basename(file, ext) + ".#{@type}")}]
      end
    end
    
    def convert(compress)        
      @assets.each do |asset|
        asset.content = Stylus.compile(asset.content, :compress => compress)
      end
    end
    
    def bundle
      content = @assets.map do |a|
        a.content
      end.join("\n")
      
      hash = Digest::MD5.hexdigest(content)
      @assets = [Asset.new(content, "#{@name}-#{hash}.#{@type}")]        
    end
    
    def compress        
      @assets.each do |asset|
        asset.content = Uglifier.compile(asset.content)
      end
    end
    
    def save
      staging = File.join(@site.source, DEFAULTS[:staging], DEFAULTS[:dest], @type)
      FileUtils::mkpath(staging) unless File.directory?(staging)
      @assets.each do |asset|
        tmp_output_path = File.join(staging, asset.filename)
        puts "#{tmp_output_path}"
        File.open(tmp_output_path, 'w') do |file|
          file.write(asset.content)
        end
        # puts "#{asset.filename} saved to #{asset.output_path}"          
      end
    end
    
    def markup
      template = @type == 'css' ? '<link rel="stylesheet" type="text/css" href="%s">' : '<script type="text/javascript" src="%s"></script>'
      
      @html = @assets.map do |asset|
        template % File.join(@dest, asset.filename)
      end.join("\n")
    end
    
  end
end