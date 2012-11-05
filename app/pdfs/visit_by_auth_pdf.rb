class VisitByAuthPdf < Prawn::Document
  def initialize(visits)
    super(top_margin:70)
    text " "
    for v in visits
      group do
        text "Visit Date:#{v.visit_date}"
        text "Therapist:#{v.patient_authorization.patient.user.email}"
        text "Patient:#{v.patient_authorization.patient.patient_full_name}"
        text "Visit Notes:#{v.visit_notes}"
        text " "
        text "Speech Pathologist:___________________________"
        text " "
        text "SLP Assistant:________________________________"
        text " "
        text " "
      end
    end
  number_pages "<page> of <total>", { :start_count_at => 0, :page_filter => :all, :at => [bounds.right - 50, 0], :align => :right }
  end
end
