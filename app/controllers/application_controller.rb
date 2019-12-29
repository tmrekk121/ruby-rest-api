class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  before_action :basic_auth, except: [:signup, :index]
  before_action :index_auth, only: [:index]

  private

  def index_auth
    if request.headers['HTTP_AUTHORIZATION'].nil?
      render status: 401, json: { 'message':'Authentication Faild' }
    else
      message = { 'message':'Authentication Faild' }.to_json
      authenticate_or_request_with_http_basic(nil, message) do |user_id, password|
        @user = User.find_by(user_id: user_id)
        if @user.nil?
          render status: 404, json: { 'message':'No User found' }
        else
          user_id == @user.user_id && password == @user.password
        end
      end
    end
  end

  def basic_auth
    if request.headers['HTTP_AUTHORIZATION'].nil?
      render status: 401, json: { 'message':'Authentication Faild' }
    else
      message = { 'message':'Authentication Faild' }.to_json
      authenticate_or_request_with_http_basic(nil, message) do |user_id, password|
        if params[:user_id] != user_id && params[:user_id] != nil
          render status: 403, json: { 'message':'No Permission for Update' }
        else
          @user = User.find_by(user_id: user_id)
          if @user.nil?
            render status: 404, json: { 'message':'No User found' }
          else
            user_id == @user.user_id && password == @user.password
          end
        end
      end
    end
  end

end
# curl tmrekk121 true
# curl -X PATCH -H 'Content-Type:application/json' -H 'Authorization:Basic dG1yZWtrMTIxOnBhc3N3b3Jk' -d '{ 'nickname': 'tmrekk121', 'comment': 'auth test' }' http://0.0.0.0:3000/users/tmrekk121
# curl -X POST -H 'Content-Type:application/json' -d '{ 'user_id': 'testtest2', 'password': 'password' }' http://0.0.0.0:3000/signup
# curl -X PATCH -H 'Content-Type:application/json' -H 'Authorization:Basic VGFyb1lhbWFkYTpQYVNTd2Q0VFk=' -d '{ 'nickname': 'たろー', 'comment': '僕は元気です' }'  https://ruby-rest-api.herokuapp.com/users/TaroYamada
# curl -X POST -H 'Content-Type:application/json' -H 'Authorization:Basic dG1yZWtrMTIxOnBhc3N3b3Jk' https://ruby-rest-api.herokuapp.com/close
# curl -X POST -H 'Content-Type:application/json' -d '{ "user_id": "tmrekk121", "password": "password" }' https://ruby-rest-api.herokuapp.com/signup