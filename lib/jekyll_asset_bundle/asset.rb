module JekyllAssetBundle
  class Asset
    def initialize(content, filename)
      @content = content
      @filename = filename
      puts "#{filename}"
    end
    
    attr_accessor :content, :filename, :output_path
  end
end