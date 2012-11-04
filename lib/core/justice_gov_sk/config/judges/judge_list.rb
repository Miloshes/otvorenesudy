module JusticeGovSk
  module Config
    module Judges
      class JudgeList < JusticeGovSk::Config::ListRequest
        def url
          "#{JusticeGovSk::Config::URL.base}/Stranky/Sudcovia/SudcaZoznam.aspx"
        end
      end
    end
  end
end
