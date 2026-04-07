module DocumentsHelper
  STATUS_BADGES = {
    "ready"      => "bg-green-100 text-green-700",
    "processing" => "bg-blue-100 text-blue-700",
    "failed"     => "bg-red-100 text-red-700",
    "pending"    => "bg-gray-100 text-gray-600"
  }.freeze

  def status_badge_class(status)
    STATUS_BADGES.fetch(status, STATUS_BADGES["pending"])
  end
end
