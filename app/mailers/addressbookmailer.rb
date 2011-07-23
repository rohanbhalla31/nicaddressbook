class Addressbookmailer < ActionMailer::Base
  def registration_confirmation(addressbook)
    @addressbook = addressbook
    mail(:to => addressbook.email, :subject => "Registered",:from=>"trainingnic11@gmail.com")
  end

  def password_recovery(to,login,pass)
     @login=login
     @password=pass
     mail(:to => to, :subject => "Password Recovery",:from=>"trainingnic11@gmail.com")
  end
end
