class UsersController < ApplicationController

    def login
      #show user to login page
    end

    def attempt_login
      #after login it validate user
      if params[:username].present? && params[:password].present?
      found_user = User.where(:username => params[:username]).first #return first member of array of all users with the username = param[username]
        if found_user
        authorized_user = found_user.authenticate(params[:password])
        end
      end
      if authorized_user
        session[:user_id] = authorized_user.id
        session[:username] = authorized_user.username
        flash[:notice] = "You are now logged in."
        redirect_to(users_login_path)
      else
        flash.now[:error] = "username and password mismatched."
        render('login')
      end
    end

    def logout
      session[:user_id] = nil
      session[:username] =nil
      flash[:notice] = 'Logged out'
      redirect_to(users_login_path)
    end

    def new
      #show form for signup
      @user = User.new
    end

    def create
      #after signup this method create a user in database
      @user = User.new(user_params)
      if @user.save
        flash[:notice] = 'Your Account has been Created.Please login to continue.'
        redirect_to(users_login_path)
      else
        render('new')
      end
    end

    def show
      #show profile of a user
      @user = User.find(params[:format])
    end

    def edit
      #show form for editing a user profile
      @user = User.find(params[:id])
    end

    def update
      #after editing profile this method update profile in database
      @user = User.find(params[:id])
      if @user.update_attributes(user_params)
        flash[:notice] = 'Your Account has been updated successfully.'
        redirect_to('')
      else
        render('edit')
      end
    end

    #def delete
    #  #show confirmation message to user for deleting his profile
    #  @user = User.find(params[:id])
    #end

    def destroy
      #delete user from database
      @user = User.find(params[:id])
      @user.destroy
      flash[:notice] = "Your Account has been removed successfully."
      redirect_to('')
    end

    private
    def user_params
      #permit :password, but NOT :password_digest
      params.require(:user).permit(
        :first_name,
        :last_name,
        :email,
        :username,
        :password,
        :password_confirmation
      )
    end

end
