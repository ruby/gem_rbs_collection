require "streamio-ffmpeg"

FFMPEG.ffmpeg_binary = "/usr/local/bin/ffmpeg"
FFMPEG.logger = Logger.new($stderr)

movie = FFMPEG::Movie.new("path/to/movie.mov")

movie.duration
movie.bitrate
movie.size

movie.video_stream
movie.video_codec
movie.colorspace
movie.resolution
movie.width
movie.height
movie.frame_rate

movie.audio_stream
movie.audio_codec
movie.audio_sample_rate
movie.audio_channels
movie.audio_streams&.first&.fetch(:codec_name)

movie.valid?

movie.transcode("tmp/movie.mp4")
movie.transcode("movie.mp4") { |progress| puts progress }
movie.transcode("movie.mp4", %w(-ac aac -vc libx264 -ac 2))

options = {
  video_codec: "libx264", frame_rate: 10, resolution: "320x240", video_bitrate: 300,
  custom: %w(-vf crop=60:60:10:10 -map 0:0 -map 0:1)
}
transcoded_movie = movie.transcode("movie.mp4", options)
transcoded_movie&.video_codec

movie.transcode("movie.mp4", options, { preserve_aspect_ratio: :width })
movie.transcode("movie.mp4", {}, { input_options: { framerate: "1/5" } })
movie.transcode("movie.mp4", options, { validate: false })

movie.screenshot("screenshot.jpg")
movie.screenshot("screenshot.bmp", { seek_time: 5, resolution: "320x240" })
movie.screenshot("screenshot_%d.jpg", { vframes: 20, frame_rate: "1/6" }, { validate: false })

slideshow_transcoder = FFMPEG::Transcoder.new(
  "",
  "slideshow.mp4",
  { resolution: "320x240" },
  { input: "img_%03d.jpeg", input_options: { framerate: "1/5" } }
)
slideshow_transcoder.command
slideshow = slideshow_transcoder.run
slideshow&.duration

FFMPEG::Transcoder.timeout = 10
FFMPEG::Transcoder.timeout = false

begin
  movie.transcode("movie.mp4")
rescue FFMPEG::Error => e
  e.message
end
