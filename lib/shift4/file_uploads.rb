# frozen_string_literal: true

module Shift4
  class FileUploads
    extend TransactionBase

    def self.upload(file, params, config = Configuration)
      body = { file: file }.merge(params)
      communicator.post("#{config.uploads_url}/files", body: body, config: config)
    end

    def self.list(params = nil, config = Configuration)
      communicator.get("#{config.uploads_url}/files", query: params, config: config)
    end

    def self.retrieve(file_upload_id, config = Configuration)
      communicator.get("#{config.uploads_url}/files/#{file_upload_id}", config: config)
    end
  end
end
