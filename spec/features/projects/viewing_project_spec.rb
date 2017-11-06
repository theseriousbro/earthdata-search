require 'spec_helper'

describe "Viewing Single Project", reset: false do

  context 'for a saved project' do
    before :all do
      Capybara.reset_sessions!
      load_page :search
      login
      visit_project
    end

    it 'shows project title' do
      expect(page).to have_css('.save-icon')
      expect(page).to have_css('h2', text: 'Test Project')
    end
  end

  context 'for an un-saved project' do
    before :all do
      Capybara.reset_sessions!
      load_page :search, project: ['C14758250-LPDAAC_ECS']
      login
      click_link 'My Project'
    end

    it 'shows default project title' do
      expect(page).to have_css('h2', text: 'Untitled Project')
      expect(page).to have_css('.save-icon')
    end
  end

  context 'project summary' do
    before :all do
      Capybara.reset_sessions!
      load_page :search, project: ['C14758250-LPDAAC_ECS']
      login
      click_link 'My Project'
      wait_for_xhr
    end

    it 'shows total in-project collections, granules, and size' do
      expect(page).to have_content('2813384 Granules 1 Collection 269.8 TB')
    end
  end

  context 'project configurations' do
    before :all do
      Capybara.reset_sessions!
      load_page :search, project: ['C1200237736-MMT_1'], env: :sit
      login
      click_link 'My Project'
      wait_for_xhr
    end

    it 'shows configuration icons' do
      within '.collection-capability' do
        expect(page).to have_css('span', count: 3)
        expect(page).to have_css('span.enabled', count: 0)

        expect(page).to have_css('i.fa.fa-globe')
        expect(page).to have_css('i.fa.fa-tags')
        expect(page).to have_css('i.fa.fa-sliders')
      end
    end
  end

  context 'project configurations with spatial subsetting enabled via bounding box' do
    before :all do
      Capybara.reset_sessions!
      load_page :search, project: ['C1200237736-MMT_1'], env: :sit, bounding_box: [0, 0, 2, 2]
      login
      click_link 'My Project'
      wait_for_xhr
    end

    it 'shows configuration icons with spatial enabled' do
      within '.collection-capability' do
        expect(page).to have_css('span', count: 3)
        expect(page).to have_css('span.enabled', count: 1)

        within 'span.enabled' do
          expect(page).to have_css('i.fa.fa-globe')
        end
        expect(page).to have_css('i.fa.fa-tags')
        expect(page).to have_css('i.fa.fa-sliders')
      end
    end
  end

  context 'project configurations with spatial subsetting enabled via polygon' do
    before :all do
      Capybara.reset_sessions!
      load_page :search, project: ['C1200237736-MMT_1'], env: :sit, polygon: [20, 102, 40, 103, 60, 104, 80, 105]
      login
      click_link 'My Project'
      wait_for_xhr
    end

    it 'shows configuration icons with spatial enabled' do
      within '.collection-capability' do
        expect(page).to have_css('span', count: 3)
        expect(page).to have_css('span.enabled', count: 1)

        within 'span.enabled' do
          expect(page).to have_css('i.fa.fa-globe')
        end
        expect(page).to have_css('i.fa.fa-tags')
        expect(page).to have_css('i.fa.fa-sliders')
      end
    end
  end

  context 'project card' do
    before :all do
      Capybara.reset_sessions!
      load_page :search, project: ['C14758250-LPDAAC_ECS', 'C1000000000-LANCEAMSR2']
      login
      click_link 'My Project'
      wait_for_xhr
    end

    it 'shows project title' do
      within '.collection-card:first-child' do
        expect(page).to have_content('ASTER L1A Reconstructed Unprocessed Instrument Data V003')
      end
    end

    it 'shows total number of granules included in the project' do
      within '.collection-card:first-child' do
        expect(page).to have_content('2813384 Granules')
      end
    end

    it 'shows estimated total granule size' do
      within '.collection-card:first-child' do
        expect(page).to have_content('Estimated Size: 269.8 TB')
      end
    end

    it 'truncates long project title' do
      within '.collection-card:nth-child(2)' do
        expect(page).to have_content('NRT AMSR2 L2B GLOBAL SWATH GSFC PROFILING ALGORITHM 2010: SURFACE PRECIPITATION, WIND SPEED OVER OCEAN...')
        expect(page).to have_css("h3[title='NRT AMSR2 L2B GLOBAL SWATH GSFC PROFILING ALGORITHM 2010: SURFACE PRECIPITATION, WIND SPEED OVER OCEAN, WATER VAPOR OVER OCEAN AND CLOUD LIQUID WATER OVER OCEAN V0']")
      end
    end
  end
end
