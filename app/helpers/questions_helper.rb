module QuestionsHelper
  CONFIDENCE_LEVELS = {
    high:   { threshold: 0.4,  label: "High",   text_color: "text-green-600", bar_color: "bg-green-500" },
    medium: { threshold: 0.15, label: "Medium", text_color: "text-yellow-600", bar_color: "bg-yellow-400" },
    low:    { threshold: 0.0,  label: "Low",    text_color: "text-red-500", bar_color: "bg-red-400" }
  }.freeze

  def confidence_level(score)
    CONFIDENCE_LEVELS.each_value do |level|
      return level if score >= level[:threshold]
    end
  end

  def confidence_label(score)
    confidence_level(score)[:label]
  end

  def confidence_text_color(score)
    confidence_level(score)[:text_color]
  end

  def confidence_bar_color(score)
    confidence_level(score)[:bar_color]
  end
end
