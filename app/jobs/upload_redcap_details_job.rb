class UploadRedcapDetailsJob < ApplicationJob
  queue_as :redcap_upload

  def perform(step_id)
    redcap_instrument = RedcapInstrumentService.new(step_id)
    redcap_instrument.update
  end
end
