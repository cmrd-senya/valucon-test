RSpec.feature 'Upload feature' do
  scenario 'Submitting a photo' do
    visit '/'
    find(:file_field).set(Rails.root + 'spec/fixtures/image.png')
    find(:xpath, '//button')
    click_on 'Submit'

    expect(page).to have_content('Our memes collection')
    expect(page).to have_xpath("//img[@src=\"#{Photo.last.image.url}\"]")
  end
end
