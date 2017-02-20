RSpec.feature 'Feedback feature' do
  scenario 'leaving a feedback' do
    visit '/'
    click_on 'Leave a feedback'
    fill_in 'email', with: 'alice@example.com'
    fill_in 'feedback_text', with: "Can't find how to sign in"
    click_on 'Post'

    expect(page).to have_content('Feedback submitted!')
    expect(find("input[name='email']").value).to eq ''
    expect(find("textarea[name='feedback_text']").value).to eq ''
  end

  scenario 'leaving an empty feedback' do
    visit '/'
    click_on 'Leave a feedback'
    fill_in 'email', with: 'alice@example.com'
    click_on 'Post'

    expect(page).to have_content('Please fill the form fields properly')
  end
end
