module JekyllAssetBundle    
  DEFAULTS = {
    :source => '/_assets',
    :dest => '/assets',
    :staging => '.assetbundle'
  }
end

require 'jekyll_asset_bundle/asset'
require 'jekyll_asset_bundle/asset_tag'
require 'jekyll_asset_bundle/pipeline'
require 'jekyll_asset_bundle/site_patch'