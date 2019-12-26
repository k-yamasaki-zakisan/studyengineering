require 'rails_helper'

feature "DeviseRegistrations" do
  scenario "user Sign up, update, destroy" do
    visit root_path

    click_link "新規登録"
    fill_in "ユーザー名", with: "sample"
    fill_in "メールアドレス", with: "sample@example.com"
    fill_in "パスワード", with: "1111111"
    fill_in "パスワード (確認)", with: "1111111"
    click_button "Sign up"

    click_link "ユーザー情報の編集"
    fill_in "ユーザー名", with: "テスト"
    fill_in "メールアドレス", with: "test@example.com"
    click_button "編集を確定する"
    expect(page).to have_current_path "/"
    expect(page).to have_content "アカウントが更新されました。"

    click_link "ユーザー情報の編集"
    expect(page.driver.browser.switch_to.alert.text).to eq "本当に退会しますか？？"
    page.driver.browser.switch_to.alert.dismiss
    click_link "アカウントを削除"
  end

  scenario "user does not signup" do
    user = FactoryBot.create(:user)

    visit root_path

    click_link "新規登録"
    click_button "新規登録"
    expect(page).to have_content "name"
    expect(page).to have_content "email"
    expect(page).to have_content "new-password"

    fill_in "ユーザー名", with: user.name
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    fill_in "パスワード (確認)", with: user.password
    click_button "新規登録"
    expect(page).to have_content "メールアドレスはすでに存在します"
  end

  scenario "user does not edit" do
    user = FactoryBot.create(:user)
    login_as(user)

    visit root_path
    click_link "アカウント"
    click_link "設定"
    click_button "ユーザー情報を更新"
    expect(page).to have_content "Current passwordを入力してください"
  end
end