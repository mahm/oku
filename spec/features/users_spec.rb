require 'rails_helper'

feature '新規ユーザー登録', type: :feature do
  let(:email) { 'foo@bar.com' }

  scenario '正常なサインアップ' do
    visit root_path
    click_on 'サインイン'
    expect(current_path).to eq(new_user_session_path)
    click_on 'こちらへ'
    expect(current_path).to eq(new_user_registration_path)
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: 'xxx'
    fill_in 'user[password_confirmation]', with: 'xxx'
    click_on '新規ユーザー登録'
    expect(page).to have_content('Welcome!')
    expect(page).to have_link(email)
  end
end

feature '既存ユーザーのサインインとサインアウト', type: :feature do
  let(:email) { 'foo@bar.com' }
  let(:password) { 'xxx' }

  before do
    User.create!(email: email, password: password)
    visit root_path
    click_link 'サインイン'
    expect(current_path).to eq(new_user_session_path)
  end

  scenario '正常なサインインとサインアウト' do
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: password
    click_button 'サインイン'
    expect(current_path).to eq(root_path)
    expect(page).to have_content('サインインしました')
    expect(page).to have_link(email)
    click_link 'サインアウト'
    expect(current_path).to eq(root_path)
    expect(page).to have_content('サインアウトしました')
  end

  scenario 'email と password を入力しなければ、サインインできない' do
    click_button 'サインイン'
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('Email もしくは Password が正しくありません')
  end

  scenario 'email が入力されていても password が未入力もしくは間違っていればサインインできない' do
    fill_in 'user[email]', with: email
    click_button 'サインイン'
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('email もしくは password が正しくありません')
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: 'wrong password'
    click_button 'サインイン'
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('Email もしくは Password が正しくありません')
    fill_in 'user[email]', with: email
    fill_in 'user[password]', with: ''
    click_button 'サインイン'
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('email もしくは password が正しくありません')
  end

  scenario '正しい password が入力されていても email が未入力もしくは間違っていればサインインできない' do
    fill_in 'user[password]', with: password
    click_button 'サインイン'
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('Email もしくは Password が正しくありません')
    fill_in 'user[password]', with: password
    fill_in 'user[email]', with: 'xxx@yyy.com'
    click_button 'サインイン'
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('email もしくは password が正しくありません')
    fill_in 'user[password]', with: password
    fill_in 'user[email]', with: ''
    click_button 'サインイン'
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('Email もしくは Password が正しくありません')
  end
end
