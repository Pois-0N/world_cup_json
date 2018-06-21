# frozen_string_literal: true

module Scrapers
  class BaseScraper
    attr_accessor :browser, :page

    def initialize
      @browser = init_browser
      @page = nil
    end

    private

    def init_browser
      options = Selenium::WebDriver::Chrome::Options.new
      if (chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil))
        options.add_argument "no-sandbox"
        options.binary = chrome_bin
        Selenium::WebDriver::Chrome.driver_path = "/app/.chromedriver/bin/chromedriver"
      end
      options.add_argument "window-size=1920x1080"
      options.add_argument "headless"
      options.add_argument "disable-gpu"
      Watir::Browser.new :chrome, options: options
    end

    def scrape_page_from_url(before_events: false)
      raise 'Must set url' unless @url
      @browser.goto(@url)
      before_scrape_events if before_events
      @page = Nokogiri::HTML(@browser.html)
    end

    def before_scrape_events
      # override
    end
  end
end
