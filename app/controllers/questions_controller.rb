class QuestionsController < ApplicationController
  def show; end

  def new
    @documents = Document.ready.order(:title)
  end

  def create
    question = params[:question].to_s.strip

    if question.blank?
      redirect_to new_question_path, alert: "Please enter a question."
      return
    end

    unless Document.ready.exists?
      redirect_to new_question_path, alert: "No documents are ready yet. Please wait for processing to complete."
      return
    end

    results = Retriever.call(question)
    @answer = AnswerBuilder.call(question, results)

    render :show
  end
end
