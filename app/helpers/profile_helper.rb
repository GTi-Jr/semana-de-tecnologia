module ProfileHelper
	def render_package
		if current_user.is_there_package?
			render :partial => 'profile/my_package_button' 
		else
			render :partial => 'profile/my_package' 
		end
	end		
	
  def is_pre_week(event)
    user = @user
    result = $redis.sismember "cart#{user.id}", event 
    result  
  end
end
