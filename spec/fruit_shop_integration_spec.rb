require 'spec_helper'

RSpec.describe "fruit_shop integration", type: :aruba do
  context "with valid options" do
    describe "when passed -h (help) flag" do
      before do
        run "fruit_shop -h"
      end

      it "outputs watermelons option" do
        expect(last_command_started).to have_output /--watermelons COUNT/
      end

      it "outputs rockmelons option" do
        expect(last_command_started).to have_output /--rockmelons COUNT/
      end

      it "outputs pineapples option" do
        expect(last_command_started).to have_output /--pineapples COUNT/
      end

      it { expect(last_command_started).to be_successfully_executed }
    end

    describe "when given a packable order" do
      before do
        run "fruit_shop --watermelons 12 --rockmelons 24 --pineapples 15"
      end

      it "outputs order subtotals and total" do
        valid_output = <<~HEREDOC
                         12 Watermelons $27.96
                          - 4 x 3 pack @ $6.99
                         24 Rockmelons $45.88
                          - 2 x 3 pack @ $5.95
                          - 2 x 9 pack @ $16.99
                         15 Pineapples $50.85
                          - 3 x 5 pack @ $16.95
                         TOTAL: $124.69
                       HEREDOC
        expect(last_command_started).to have_output valid_output.strip
      end

      it { expect(last_command_started).to be_successfully_executed }
    end
  end

  context "with invalid options" do
    describe "when given no options" do
      before do
        run "fruit_shop"
      end

      it "outputs an error message" do
        expect(last_command_started).to have_output(
          /Empty order, try -h for available options/
        )
      end

      it { expect(last_command_started).to_not be_successfully_executed }
    end

    describe "when given an order count less than 1" do
      before do
        run "fruit_shop --watermelons -1"
      end

      it "outputs an error message" do
        expect(last_command_started).to have_output(
          /Please enter a number greater than 0/
        )
      end

      it { expect(last_command_started).to_not be_successfully_executed }
    end

    describe "when given a non-integer order count" do
      before do
        run "fruit_shop --watermelons AAA"
      end

      it "outputs an error message" do
        expect(last_command_started).to have_output(
          /invalid argument: --watermelons AAA/
        )
      end

      it { expect(last_command_started).to_not be_successfully_executed }
    end

    describe "when given an unpackable order" do
      before do
        run "fruit_shop --watermelons 1"
      end

      it "outputs message stating which product could not be packed" do
        expect(last_command_started).to have_output(
          /Could not pack your Watermelons/
        )
      end

      it "outputs message stating valid pack sizes" do
        expect(last_command_started).to have_output(
          /3, 5/
        )
      end

      it { expect(last_command_started).to_not be_successfully_executed }
    end
  end
end