require 'spec_helper'

describe "Granule Display Name", reset: false do
  extend Helpers::CollectionHelpers

  before :all do
    Capybara.reset_sessions!
    load_page :search
  end

  context "when granule has producer_granule_id" do
    use_collection 'C4543622-LARC_ASDC', 'CER_SSF_Terra-FM1-MODIS_Edition3A'
    hook_granule_results('CER_SSF_Terra-FM1-MODIS_Edition3A')

    it "displays the producer_granule_id as the name" do
      expect(page).to have_content("CER_SSF_Terra-FM1-MODIS_Edition3A")
    end
  end
end
