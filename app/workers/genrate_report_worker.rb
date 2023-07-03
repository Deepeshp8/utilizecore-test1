class GenrateReportWorker
  include Sidekiq::Worker

  def perform(*args)
    #Call method to Generate report 
    Report.generate_parcel_report_daily
  end
end
