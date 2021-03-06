module JusticeGovSk
  module Job
    class ListCrawler
      extend JusticeGovSk::Helper::UpdateController::Resource

      @queue = :listers

      # supported types: CivilHearing, SpecialHearing, CriminalHearing, Decree
      def self.perform(type, options = {})
        type = type.to_s.constantize

        options.symbolize_keys!

        raise "No offset" unless options[:offset]
        raise "No limit"  unless options[:limit]

        request, lister = JusticeGovSk.build_request_and_lister type, options

        JusticeGovSk.run_lister lister, request, options do
          lister.crawl(request, options[:offset], options[:limit]) do |url|
            next unless crawlable? type, url
            Resque.enqueue(JusticeGovSk::Job::ResourceCrawler, type.name, url, options)
          end
        end
      end
    end
  end
end
