class IncidentDecorator < SimpleDelegator
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers

  def short_status
    case status
    when Incident::STATUS_OPEN
      'open'
    when Incident::STATUS_CLOSE
      'close'
    end
  end

  def short_summary
    "#{short_status} [noty alert]"
  end

  def subject
    "━ [noty alert][#{status == 'close' ? 'UP' : 'DOWN'}] #{incident.check.uri}"
  end

  def url
    incident_url(self)
  end

  def duration
    diff = updated_at - created_at
    hour = (diff / 3600).to_i
    if hour >= 1
      minute = (diff - (hour * 3600)).to_i / 60
      "#{pluralize(hour.to_i, 'hour')} #{pluralize(minute, 'minute')}"
    else
      minute = (diff / 60).to_i
      pluralize(minute, 'minute')
    end
  end

  # How many time this happen
  def frequency
    Incident.where(assertion: self.assertion).count
  end
end
