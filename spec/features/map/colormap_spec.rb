require 'spec_helper'

describe 'Collection Colormaps', reset: false do
  gibs_collection_id = 'C119124186-NSIDC_ECS'
  gibs_collection_name = 'AMSR-E/Aqua L2B Global Swath Rain Rate/Type GSFC Profiling Algorithm V002'
  non_gibs_collection_id = 'C179003030-ORNL_DAAC'
  non_gibs_collection_name = '15 Minute Stream Flow Data: USGS (FIFE)'
  gibs_granules_collection_id = 'C187016591-LPDAAC_ECS'
  gibs_granules_collection_name = 'MODIS/Terra Land Surface Temperature/Emissivity 5-Min L2 Swath 1km V041'

  before :all do
    load_page :search
  end

  context "when viewing a GIBS-enabled collection" do
    before :all do
      # load_page :search
      fill_in 'keywords', with: gibs_collection_id
      wait_for_xhr
      expect(page).to have_content("AE_Rain")
      view_granule_results(gibs_collection_name)
      wait_for_xhr
    end

    after :all do
      reset_search
    end

    it "shows the GIBS colormap" do
      expect(page).to have_css(".legend.leaflet-control", visible: true)
    end

    context "when returning to the collection results" do
      before :all do
        find('.master-overlay-main-content').find('a', text: 'Back to Collections', match: :prefer_exact).click
      end

      it "removes the colormap" do
        expect(page).to have_no_css(".legend.leaflet-control", visible: true)
      end
    end
  end

  context "when viewing a non-GIBS-enabled collection" do
    before :all do
      fill_in 'keywords', with: non_gibs_collection_id
      wait_for_xhr
      expect(page).to have_content("doi:10.3334/ORNLDAAC/1")
      view_granule_results(non_gibs_collection_name)
      wait_for_xhr
    end

    after :all do
      find('.master-overlay-main-content').find('a', text: 'Back to Collections', match: :prefer_exact).click
      reset_search
    end

    it "does not show a colormap" do
      expect(page).to have_css(".legend.leaflet-control", visible: false)
    end

  end

  context "when viewing the GIBS-granule test collection" do
    before :all do
      fill_in 'keywords', with: gibs_granules_collection_id
      wait_for_xhr
      expect(page).to have_content("MOD11_L2")
      view_granule_results(gibs_granules_collection_name)
      wait_for_xhr
    end

    it "shows the GIBS colormap" do
      expect(page).to have_css(".legend.leaflet-control", visible: true)
    end

    after :all do
      find('.master-overlay-main-content').find('a', text: 'Back to Collections', match: :prefer_exact).click
      reset_search
    end
  end
end
