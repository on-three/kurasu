
ifndef EP
$(error episode number is not defined. e.g. EP=02)
endif

GROUP := [squap]
SERIES := 考えるカラス(Thinking.Crow)
OUTNAME := $(GROUP)$(SERIES).s01e$(EP)
NAME := Thinking.Crow.s01e$(EP)

OUT_DIR := ./$(GROUP)$(SERIES)
SUBS_DIR := ./subs
DATA_DIR := ./data
VIDEO_DIR := ./video
TORRENT_DIR := ./torrent

TS := $(VIDEO_DIR)/$(NAME).ts
MKV_FILE := $(OUTNAME).mkv
MKV := $(OUT_DIR)/$(MKV_FILE)
SRT_EN := $(SUBS_DIR)/$(NAME).en_us.srt
SRT_JP := $(SUBS_DIR)/$(NAME).ja_jp.srt
ASS_EN := $(SUBS_DIR)/$(NAME).en_us.ass

INCOMING := ~/incoming
TORRENT := $(TORRENT_DIR)/$(OUTNAME).torrent
TRACKER := http://nyaa.tracker.wf:7777/announce


# input m3u8 file (from nhke site) must be named appropriately after download
M3U8 := $(DATA_DIR)/ep$(EP).m3u8

# input ttml subs (from nhke site) must be named appropriately after download
TTML := $(DATA_DIR)/ep$(EP).ttml


# tools
FFMPEG := ffmpeg
TTML2SRT := /home/on-three/code/ttml/ttml/convert.py
MIXTAPE := uploadtomixtape.sh

all: $(SRT_EN) $(MKV)

$(OUT_DIR):
	mkdir -p "$@"

download: $(M3U8)
	$(FFMPEG) -i $(M3U8) -c copy $(TS)

$(MKV): $(TS) $(SRT_JP) $(ASS_EN)
	mkdir -p "$(@D)"
	$(FFMPEG) -i $(TS) -i $(ASS_EN) -i $(SRT_JP) \
	-map 0:v -map 0:a -map 1 -map 2 \
	-metadata:s:s:0 language=eng -metadata:s:s:1 language=jpn "$@"

$(SRT_JP): $(TTML)
	$(TTML2SRT) "$^" -o "$@"

$(SRT_EN): $(SRT_JP)
	cp "$^" "$@"

$(INCOMING)/$(MKV_FILE): $(MKV)
	cp "$<" "$@"

torrent: $(TORRENT)

$(TORRENT): $(INCOMING)/$(MKV_FILE)
	mkdir -p $(TORRENT_DIR)
	ctorrent -t -u "$(TRACKER)" -s "$@" "$<"

mixtape: $(MKV)
	# upload to mixtape.moe to share
	$(MIXTAPE) "$^"

