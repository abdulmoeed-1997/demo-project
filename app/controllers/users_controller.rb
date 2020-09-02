class UsersController < ApplicationController
	before_action :confirm_logged_in,     only: [:show, :edit, :update, :destroy]
	before_action :destroy_user_session,  only: [:logout]
	
	def new
		@user = User.new
	end
	
	def create
		@user = User.new(user_params)

		if @user.save
			flash[:notice] = 'Your Account has been Created.Please login to continue.'
			@shoppingcart = ShoppingCart.create(user_id: @user.id)
			redirect_to(login_user_path)
		else
			render('new')
		end
	end

	def show
		@user = @current_user
		@products = @current_user.products.last(6)
	end

	def edit
		@user = @current_user
	end

	def update
		if @current_user.update_attributes(user_params)
			if params[:user][:delete_avatar] == "1"
				@current_user.avatar.purge
			end
			flash[:notice] = 'Your Account has been updated successfully.'
			redirect_to(user_path)
		else
			render('edit')
		end
	end

	def destroy
		@current_user.destroy
		destroy_user_session
		flash[:notice] = "Your Account has been removed successfully."
		redirect_to(new_user_path)
	end

	def login
		if @current_user
			redirect_to(home_path) and return
		end
		if params[:checkout].present?
			session[:checkout] = 1
		end
	end

	def logout
		flash[:notice] = 'Logged out'
		redirect_to(login_user_path)
	end

	def attempt_login
		if params[:username].present? && params[:password].present?
			found_user = User.where(:username => params[:username]).first

			if found_user
				authorized_user = found_user.authenticate(params[:password])
				
				if authorized_user
					set_user_session(authorized_user)
					
					if session[:checkout]
						session[:checkout] = nil
						redirect_to(assign_cart_to_user_shopping_carts_path) and return
					end
					flash[:notice] = "You are now logged in."
					redirect_to(home_path) and return
				end
			end
		end
		flash.now[:error] = "username and password mismatched."
		render('login')
	end

	private

	def user_params
		params.require(:user).permit(
			:first_name,
			:last_name,
			:email,
			:username,
			:password,
			:password_confirmation,
			:avatar,
			:delete_avatar
		)
	end

	def set_user_session(user)
		session[:user_id] = user.id
		session[:username] = user.username
	end

	def destroy_user_session
		session[:user_id] = nil
		session[:username] =nil
	end
	
end