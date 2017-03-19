require 'trinity/current'
require 'trinity/policy'

module Api
  module Bot
    class BotController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :require_bot_account

      private
      def current
        @current
      end

      # Find associated user with this bot account
      def require_bot_account
        # TODO: Probably we should use a right authentication strategy?
        if token = request.headers['HTTP_X_BOT_TOKEN']
          begin
            bot = BotAccount.find_by(token: token)
            @current = Trinity::Current.new bot.user
          rescue
            head :forbidden
          end
        else
          head :forbidden
        end
      end
    end
  end
end
