module JekyllAssetBundle
  class AssetTag < Liquid::Tag
  
    def render context            
      site = context.registers[:site]
      
      # Run Jekyll Asset Pipeline        
      pipeline, cached = Pipeline.run(@markup.strip, @tag_name, site)
      
      staging = File.join(site.source, DEFAULTS[:staging])
      output = File.join(DEFAULTS[:dest], @tag_name)
      pipeline.assets.each do |asset|          
        site.static_files << Jekyll::StaticFile.new(site, staging, output, asset.filename)
      end unless cached
      
      return pipeline.html
    end
  end
end

%w{ js css }.each do |tag|
  Liquid::Template.register_tag tag, JekyllAssetBundle::AssetTag
end