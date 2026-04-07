module Api
  module V1
    class QuestionsController < BaseController
      def create
        question = params[:question].to_s.strip

        if question.blank?
          render json: { error: "Question is required." }, status: :unprocessable_content
          return
        end

        unless Document.ready.exists?
          render json: { error: "No documents are ready yet." }, status: :service_unavailable
          return
        end

        results = Retriever.call(question)
        answer  = AnswerBuilder.call(question, results)

        render json: AnswerSerializer.new(answer)
      end
    end
  end
end
