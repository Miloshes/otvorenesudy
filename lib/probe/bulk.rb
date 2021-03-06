module Probe
  class Bulk
    def self.import(model)
      model.delete_index
      model.create_index

      model.index.import(model, method: :bulk, per_page: 5000)

      model.index.refresh

      # model.alias_index_as(bulk_index) # TODO: use when percolating alias indices works in elasticsearch
    end

    def self.async_import(model)
      Resque.enqueue(AsyncImport, model.to_s)
    end

    def self.update(model)
      model.update_index
    end

    def self.async_update(model)
      Resque.enqueue(AsyncUpdate, model.to_s)
    end
  end

  class AsyncImport
    @queue = :probe

    def self.perform(model)
      Probe::Bulk.import(model.constantize)
    end
  end

  class AsyncUpdate
    @queue = :probe

    def self.perform(model)
      Probe::Bulk.update(model.constantize)
    end
  end
end
