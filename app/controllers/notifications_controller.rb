class NotificationsController < ApplicationController
  def index
    set_page_and_extract_portion_from Current.user.notifications.read.ordered

    if @page.first?
      @unread = Current.user.notifications.unread.ordered
    end

    respond_to do |format|
      format.turbo_stream if current_page_param # Allows read-all action to side step pagination
      format.html
    end
  end
end
