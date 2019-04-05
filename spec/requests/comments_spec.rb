require 'rails_helper'

RSpec.describe "Comments", type: :request do
  before(:each) do #This logins the user
    @user = FactoryBot.create(:user)
    @article = FactoryBot.create(:article)

    visit root_path
    expect(current_path).to eq(new_user_session_path)
    expect(current_path).to_not eq(root_path)

    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log in'
    end

    expect(current_path).to eq(root_path)
    expect(current_path).to_not eq(new_user_session_path)
    expect(page).to have_content('Signed in successfully.')
  end

  describe 'GET #index' do
    describe 'valid: ' do
      it 'should return a list of comments' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comment'
        expect(current_path).to eq(comments_path)
        expect(page).to have_content(@comment.message)

      end
    end

    describe 'invalid: ' do
    end
  end

  describe 'GET #show' do
    describe 'valid: ' do
      it 'should return a comment' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        expect(page).to have_content(@comment.message)

        click_link "Show"
        expect(current_path).to eq(comment_path(@comment))

        expect(page).to have_content(@comment.user.email)
        expect(page).to have_content(@comment.article.title)
        expect(page).to have_content(@comment.message)
      end
    end

    describe 'invalid: ' do
      it 'should not return an article if one does not exist' do
        visit comment_path(99999)
        expect(current_path).to eq(comments_path)
        expect(page).to have_content("The comment you're looking for cannot be found")
      end
    end
  end

  describe 'GET #new' do
    describe 'valid: ' do
      it 'should create a new comment with valid attributes' do

        click_link "Comments"
        expect(current_path).to eq(comments_path)

        click_link 'New Comment'
        expect(current_path).to eq(new_comment_path)



        fill_in 'comment_message', with: 'New_Comment'

        check('comment_visible')

        select @article.title, from: 'comment[article_id]'
        select @user.email, from: 'comment[user_id]'

        click_button 'Create Comment'
        expect(page).to have_content('Comment was successfully created.')
        expect(page).to have_content('New_Comment')
      end
    end

    describe 'invalid: ' do
      it 'should not create a new comment with invalid attributes' do
        click_link "Comments"
        expect(current_path).to eq(comments_path)

        click_link 'New Comment'
        expect(current_path).to eq(new_comment_path)
        //
        fill_in 'comment_message', with: ''
        select @article.title, from: 'comment[article_id]'
        select @user.email, from: 'comment[user_id]'
        click_button 'Create Comment'
        expect(page).to have_content("Message can't be blank")
      end
    end
  end

  describe 'GET #edit' do
    describe 'valid: ' do
      it 'should update a comment with valid attributes' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        expect(page).to have_content(@comment.message)

        click_link "Show"
        expect(current_path).to eq(comment_path(@comment))

        expect(page).to have_content(@comment.article.title)
        expect(page).to have_content(@comment.message)

        @new_user = FactoryBot.create(:user)

        click_link "Edit"
        expect(current_path).to eq(edit_comment_path(@comment))

        fill_in 'comment_message', with: 'Edited_Comment_Message'
        select @article.title, from: 'comment[article_id]'
        select @new_user.email, from: 'comment[user_id]'
        click_button 'Update Comment'

        expect(page).to have_content('Comment was successfully updated.')
        expect(page).to have_content('Edited_Comment_Message')
        expect(current_path).to eq(comment_path(@comment))
      end
    end

    describe 'invalid: ' do
      it 'should not update a comment with invalid attributes' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        expect(page).to have_content(@comment.message)

        click_link "Show"
        expect(current_path).to eq(comment_path(@comment))

        expect(page).to have_content(@comment.user.email)
        expect(page).to have_content(@comment.article.title)
        expect(page).to have_content(@comment.message)

        click_link "Edit"
        expect(current_path).to eq(edit_comment_path(@comment))

        fill_in 'comment_message', with: ''
        click_button 'Update Comment'

        expect(page).to have_content("Message can't be blank")
      end
    end
  end

  describe "DELETE #destroy" do
    describe 'valid: ' do
      it 'should destroy an comment when destroy is clicked' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)

        expect(page).to have_content(@comment.message)
        click_link 'Destroy'

        expect(current_path).to eq(comments_path)
        expect(page).to have_content("Comment was successfully destroyed.")
      end
    end
  end
end
