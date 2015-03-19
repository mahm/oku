require 'rails_helper'

feature 'ユーザー認証', type: :feature do
  given(:email) { 'foo@bar.com' }
  given(:password) { 'xxx' }

  before(:each) do
    visit root_path
    click_on 'サインイン'
    expect(current_path).to eq(new_user_session_path)
  end

  feature '新規ユーザー登録（サインアップ）' do
    before(:each) do
      click_on 'こちらへ'
      expect(current_path).to eq(new_user_registration_path)
    end
    context 'email, password, password_confirmation 全てが入力されている' do
      context 'password と password_confirmation が一致する' do
        scenario '正常にサインアップが完了し、トップページへ遷移する' do
          expect{
            fill_in 'user[email]', with: email
            fill_in 'user[password]', with: password
            fill_in 'user[password_confirmation]', with: password
            click_on '新規ユーザー登録'
          }.to change(User, :count).by(1)
          expect(current_path).to eq(root_path)
          expect(page).to have_content(email)
          expect(page).to have_content('サインアウト')
        end
      end
      context 'password と password_confirmation が一致しない' do
        scenario 'サインアップできない' do
          fill_in 'user[email]', with: email
          fill_in 'user[password]', with: password
          fill_in 'user[password_confirmation]', with: 'hoge'
          click_on '新規ユーザー登録'
          expect(current_path).to eq(user_registration_path)
          expect(page).to have_content('一致しません')
        end
      end
    end
    context 'email, password, password_confirmation の全てが入力されていない' do
      scenario 'サインアップできない' do
        click_on '新規ユーザー登録'
        expect(current_path).to eq(user_registration_path)
        expect(page).to have_content('入力して下さい')
      end
    end
    context 'email が入力されていない' do
      scenario 'サインアップできない' do
        click_on '新規ユーザー登録'
        fill_in 'user[password]', with: password
        fill_in 'user[password_confirmation]', with: password
        expect(current_path).to eq(user_registration_path)
        expect(page).to have_content('入力して下さい')
      end
    end
    context 'password が入力されていない' do
      scenario 'サインアップできない' do
        click_on '新規ユーザー登録'
        fill_in 'user[email]', with: email
        fill_in 'user[password_confirmation]', with: password
        expect(current_path).to eq(user_registration_path)
        expect(page).to have_content('入力して下さい')
      end
    end
    context 'password_confirmation が入力されていない' do
      scenario 'サインアップできない' do
        click_on '新規ユーザー登録'
        fill_in 'user[email]', with: email
        fill_in 'user[password]', with: password
        expect(current_path).to eq(user_registration_path)
        expect(page).to have_content('入力して下さい')
      end
    end
  end

  feature '既存ユーザーのサインイン' do
    given!(:user) { create(:user, email: email, password: password) }

    context 'email と password が入力されている' do
      context 'email と password が正しい' do
        scenario '正常にサインインが完了し、トップページへ遷移する' do
          fill_in 'user[email]', with: email
          fill_in 'user[password]', with: password
          click_button 'サインイン'
          expect(current_path).to eq(root_path)
          expect(page).to have_content(email)
          expect(page).to have_content('サインアウト')
        end
      end
      context 'email が間違っている' do
        scenario 'サインインできない' do
          fill_in 'user[email]', with: 'hogehogehoge'
          fill_in 'user[password]', with: password
          click_button 'サインイン'
          expect(current_path).to eq(user_session_path)
          expect(page).to have_content('正しくありません')
        end
      end
      context 'password が間違っている' do
        scenario 'サインインできない' do
          fill_in 'user[email]', with: email
          fill_in 'user[password]', with: 'hogehogehoge'
          click_button 'サインイン'
          expect(current_path).to eq(user_session_path)
          expect(page).to have_content('正しくありません')
        end
      end
    end
    context 'email と password が入力されていない' do
      scenario 'サインインできない' do
        click_button 'サインイン'
        expect(current_path).to eq(user_session_path)
        expect(page).to have_content('正しくありません')
      end
    end
    context 'email が入力されていない' do
      scenario 'サインインできない' do
        fill_in 'user[password]', with: password
        click_button 'サインイン'
        expect(current_path).to eq(user_session_path)
        expect(page).to have_content('正しくありません')
      end
    end
    context 'password が入力されていない' do
      scenario 'サインインできない' do
        fill_in 'user[email]', with: email
        click_button 'サインイン'
        expect(current_path).to eq(user_session_path)
        expect(page).to have_content('正しくありません')
      end
    end
  end
end
