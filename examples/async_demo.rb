#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../lib/openai"

# https://github.com/socketry/async
require "async"

client = OpenAI::Client.new

Async do
  puts("--- spawning **first** async task ---\n\n\n")
  t1 = Async do
    stream = client.responses.stream(
      input: "Write a haiku about OpenAI.",
      model: "gpt-4o-2024-08-06"
    )
    puts("--- acquired **first** stream ---\n")
    stream.each do
      # the `sleep(0)` call is here to `yield` out of a tight loop
      sleep(0)
      puts("--- printing from **first** stream ---\n#{_1.to_s[0..15]}...")
    end
  end

  puts("--- spawning **second** async task ---\n\n\n")
  t2 = Async do
    stream = client.responses.stream(
      input: "Write a haiku about OpenAI.",
      model: "gpt-4o-2024-08-06"
    )
    puts("--- acquired **second** stream ---\n")
    stream.each do
      # the `sleep(0)` call is here to `yield` out of a tight loop
      sleep(0)
      puts("--- printing from **second** stream ---\n#{_1.to_s[0..15]}...")
    end
  end

  puts("\n\n\n>>> waiting for **both** tasks <<<\n\n\n")
  [t1, t2].each(&:wait)
end
  .wait
