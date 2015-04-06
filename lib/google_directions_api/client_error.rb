module GoogleDirectionsAPI
  class ClientError < RuntimeError
    attr_reader :status

    def initialize(params)
      @status = params[:status]

      super status
    end
  end
end
