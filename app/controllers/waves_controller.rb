class WavesController < ApplicationController
  def create
    # maker = MostlyDev::WaveMaker.new wave_params
    # maker.make_waves!
  end

  private

  def wave_params
    params.require(:wave).permit :csv
  end
end

require "mostlydev/wave_maker"