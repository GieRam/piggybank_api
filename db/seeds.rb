user = User.create(username: 'Test',
            email: 'test@mail.com',
            password: 'Test123!',
            password_confirmation: 'Test123!',
            activated: true,
            activated_at: Time.zone.now)
account = Account.create(name: 'Test Account', description: 'Joint finance account')
user.accounts << account
