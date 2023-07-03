class Report < ApplicationRecord
    validates :file_name, presence: true
    before_destroy :delete_file

    #daily generate and store excel file of parcels data report 
    def self.generate_parcel_report_daily
        parcel_data = Parcel.includes(:sender,:receiver)
        file_name = "daily_report_#{Date.today}.xlsx"
        file_path = "public/reports/#{file_name}"      
        Xlsxtream::Workbook.open(file_path) do |xlsx|
            xlsx.write_worksheet 'courier details' do |sheet|
              # Boolean, Date, Time, DateTime and Numeric are properly mapped
              sheet << ['Weight','Cost','Status','Payment Mode','Sender Email','Sender Name with address','Receiver Email','Receiver Name with address']
              parcel_data.each do |data|
                sheet << [data.weight.to_s.to_f,data.cost.to_s.to_f,data.status,data.payment_mode, data.sender.email,data.sender.name_with_address,data.receiver.email,data.receiver.name_with_address]
              end
            end
        end
        self.create(file_name: file_name,file_path: file_path)
        clean_old_reports()
    end

    #Delete 30 days old reports
    def self.clean_old_reports()
        previous_30_days_records = self.where('created_at <= ?', 30.days.ago)
        if previous_30_days_records.present?
            previous_30_days_records.each do |report|
                File.delete(report.file_path) if File.exist?(report.file_path)
            end
            previous_30_days_records.destroy_all
        end
    end

    #Delete excel file
    def delete_file
        File.delete(self.file_path) if File.exist?(self.file_path)
    end
end