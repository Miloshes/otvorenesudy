module JusticeGovSk
  module Helper
    module ProceedingSupplier
      def supply_proceeding_for(instance)
        build_proceeding_by(instance.file_number) do |proceeding|
          persistor.persist(proceeding) if proceeding.id.nil?
          
          instance.proceeding = proceeding
        end
      end

      private
      
      def build_proceeding_by(file_number)
        proceeding = proceeding_by_file_number_factory.find_or_create(file_number)
        
        proceeding.file_number = file_number
        
        yield proceeding
      end
    end
  end
end