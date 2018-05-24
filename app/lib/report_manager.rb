class ReportManager
  X_SMALL_WIDTH = 10
  SMALL_WIDTH = 15
  MEDIUM_WIDTH = 20
  LARGE_WIDTH = 25
  X_LARGE_WIDTH = 50
  XX_LARGE_WIDTH = 100

  COLUMNS_WIDTH = [MEDIUM_WIDTH, X_LARGE_WIDTH, SMALL_WIDTH, XX_LARGE_WIDTH, LARGE_WIDTH, LARGE_WIDTH, MEDIUM_WIDTH].freeze

  HEADERS = ['Study ID', 'Email Address', 'Step', 'Consent Question', 'Changes From', 'Changes To', 'When'].freeze

  def self.daily_consent_changes_excel_file
    p = Axlsx::Package.new
    wb = p.workbook
    styles = wb.styles
    align_hash = { alignment: { horizontal: :center, vertical: :center, wrap_text: true } }
    margins = { left: 0.4, right: 0.4, top: 0.3, bottom: 0.3, header: 0.3, footer: 0.3 }
    setup = { fit_to_width: 1, fit_to_height: 20, orientation: :landscape, paper_size: 9 }
    header_footer = { different_first: false, odd_footer: '&R&P of &N' }
    wb.add_worksheet(name: 'Daily Consent Changes Export', page_margins: margins, page_setup: setup, header_footer: header_footer) do |sheet|
      add_table_headers(align_hash, sheet, styles)
      add_changes_data_rows(align_hash, sheet, styles)
      sheet.column_widths(*COLUMNS_WIDTH)
      wb.add_defined_name("'DailyConsentChanges'!$1:$11", local_sheet_id: sheet.index, name: '_xlnm.Print_Titles')
    end

    date_time_now_in_zone = Timezone['Australia/Melbourne'].time_with_offset(DateTime.now)
    today_date = date_time_now_in_zone.try(:strftime, '%d_%m_%Y')

    file_name_report = "#{Rails.root}/tmp/AGHA_Participant_Consent_Preference_Changes_#{today_date}.xlsx"
    p.use_shared_strings = true
    p.serialize(file_name_report)
    File.new(file_name_report)
  end

  def self.add_changes_data_rows(align_hash, sheet, styles)
    field = styles.add_style align_hash.merge(border: { style: :thin, color: '000000' }, sz: 10)
    fields_styles = [field] * HEADERS.size

    versions = Question.get_question_changes_for_last_day.sort_by(&:whodunnit)
    versions.each do |version|
      question = Question.find(version.item_id)
      step = question.step
      user = step.user
      changes = version.changeset['answer']

      event_time_in_zone = Timezone['Australia/Melbourne'].time_with_offset(version.created_at)
      version = event_time_in_zone.try(:strftime, '%d/%m/%Y %H:%M')

      current_question = QUS.values.flatten.select { |x| x[:question_id] == question.question_id }.first[:qus]
      data_row = [user.study_id, user.email, step.number, current_question, changes.first, changes.last, version]
      sheet.add_row(data_row, style: fields_styles, height: 30)
    end
  end

  def self.add_table_headers(align_hash, sheet, styles)
    sub_header_hash = align_hash.merge(border: { style: :medium, color: '000000' }, b: true, sz: 10)
    sub_header = styles.add_style sub_header_hash
    sub_header_light = styles.add_style sub_header_hash
    sub_header_left = styles.add_style sub_header_hash
    sub_header_right = styles.add_style sub_header_hash

    custom_border = styles.borders[styles.cellXfs[sub_header_left].borderId]
    custom_border.prs.each do |part|
      case part.name
      when :right
        part.style = :thin
      end
    end

    custom_border = styles.borders[styles.cellXfs[sub_header_right].borderId]
    custom_border.prs.each do |part|
      case part.name
      when :left
        part.style = :thin
      end
    end

    custom_border = styles.borders[styles.cellXfs[sub_header_light].borderId]
    custom_border.prs.each do |part|
      case part.name
      when :left
        part.style = :thin
      when :right
        part.style = :thin
      end
    end

    header_columns = HEADERS

    headers_styles = [sub_header] * header_columns.size
    sheet.add_row(header_columns, style: headers_styles, height: 25)
  end
end
