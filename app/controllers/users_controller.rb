class UsersController < ApplicationController

  def index
    user = User.find_by(user_id: params[:user_id])
    if user.nickname == nil
      render status: 200, json: {"message": "User details by user_id", "user": {"user_id": user.user_id, "nickname":user.user_id} }
    elsif user
      render status: 200, json: {"message": "User details by user_id", "user": {"user_id": user.user_id, "nickname":user.nickname} }
    elsif user == nil
      render status: 404, json: { 'message':'No User found' }
    else
      render status: 401, json: { 'message':'Authentication Faild' }
    end
  end

  def signup

    if params[:user_id].nil? || params[:password].nil?
      render status: 400, json: { message:'Account creation failed', 'cause':'required user_id and password' }
    else
      user = User.new(user_params)
      if user.save
        render status: 200, json: { message:'Account successfully created', user:{ 'user_id':user.user_id ,'nickname':user.user_id } }
      elsif user.user_id.blank? || user.password.blank?
        render status: 400, json: { message:'Account creation failed', 'cause':'required user_id and password' }
      elsif user.user_id.length < 6 || user.user_id.length > 20 || user.password.length < 8 || user.password.length > 20
        render status: 400, json: { message:'Account creation failed', 'cause':'length user_id and password' }
      elsif User.exists?(user_id: user.user_id)
        render status: 400, json: { message:'Account creation failed', 'cause':'already same user_id is used' }
      elsif !(user.password.ascii_only?) || user.password.include?(" ")
        render status: 400, json: { message:'Account creation failed', 'cause':'pattern user_id and password' }
      end
    end
  end

  def signout
    if @user.destroy
      render status: 200, json: { "message":"Account and user successfully removed" }
    else
      render status: 401, json: { "message":"Authentication Faild" }
    end
  end

  def update
    user = User.find_by(user_id: params[:user_id])
    if params[:nickname] && params[:comment]
      if user.update(user_update_params)
        render status: 200, json: { message:'User successfully updated', recipe:[{ 'nickname':user.user_id, 'comment':user.comment }] }
      elsif user == nil
        render status: 404, json: { 'message':'No User found' }
      elsif user.nickname.blank? || user.comment.blank?
        render status: 400, json: { 'message':'User updation failed', "cause": "required nickname or comment" }
      else
        render status: 400, json: { 'message':'Can not change user_id and password', "cause":"not updatable user_id and password" }
      end
    else
      render status: 400, json: { 'message':'Can not change user_id and password', "cause":"not updatable user_id and password" }
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_id, :password)
  end

  def user_update_params
    params.require(:user).permit(:nickname, :comment)
  end
end
