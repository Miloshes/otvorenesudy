module Core
  module Crawler
    include Core::Output

    attr_accessor :downloader,
                  :parser,
                  :persistor

    attr_reader :request,
                :content,
                :document,
                :result

    def initialize(downloader, parser, persistor)
      @downloader = downloader
      @parser     = parser
      @persistor  = persistor
    end

    def crawl(request, &block)
      precrawl
      process(request, &block)
      postcrawl
    end

    def verbose=(value)
      @verbose            = value
      @downloader.verbose = value unless @downloader.nil?
      @parser.verbose     = value unless @parser.nil?
      @persistor.verbose  = value unless @persistor.nil?
    end

    protected

    def precrawl
      introduce
      clear
    end

    def process(request)
      return unless @request = request

      @content  = @downloader.download(@request) unless @downloader.nil?
      @document = @parser.parse(@content) unless @parser.nil?
      @result   = yield

      @persistor.persist(@result) unless @persistor.nil?
    end

    def postcrawl(message = "finished")
      unless @request.nil?
        unless @content.nil?
          unless @document.nil?
            unless @result.nil?
              puts message

              @result
            else
              puts "aborted (no result produced)"
            end
          else
            puts "aborted (no document parsed)"
          end
        else
          puts "aborted (no content downloaded)"
        end
      else
        puts "aborted (no request provided)"
      end
    end

    private

    def introduce
      print "Running #{self.class.name} using "
      print "#{@downloader.nil? ? 'no downloader' : @downloader.class.name}, "
      print "#{@parser.nil?     ? 'no parser'     : @parser.class.name} and "
      puts  "#{@persistor.nil?  ? 'no persistor'  : @persistor.class.name}."
    end

    def clear
      @request  = nil
      @content  = nil
      @document = nil
      @result   = nil
    end
  end
end
