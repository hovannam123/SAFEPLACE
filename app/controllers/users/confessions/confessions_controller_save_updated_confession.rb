# frozen_string_literal: true

module Users
  module Confessions
    # module Confessions Controller contain private method for update action
    module ConfessionsControllerSaveUpdatedConfession
      extend ActiveSupport::Concern

      included do
        private

        def broadcast_updated_confession
          Turbo::StreamsChannel
            .broadcast_replace_later_to('confessions_index_channel',
                                        target: helpers.dom_id(@confession),
                                        partial: 'users/confessions/confession_index',
                                        locals: { user: current_user, confession: @confession })
          Turbo::StreamsChannel
            .broadcast_update_later_to('confessions_show_channel',
                                       target: "#{helpers.dom_id(@confession)}_show",
                                       partial: 'users/confessions/confession',
                                       locals: { confession: @confession })
        end

        def handle_failed_update_confession
          respond_to do |format|
            format.turbo_stream do
              flash.now[:alert] =
                helpers.sanitize("<ul><li>#{@confession.errors.full_messages.join('</li><li>')}</li><ul>")
              render status: :unprocessable_entity
            end
            format.json { render json: @confession.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end
end
