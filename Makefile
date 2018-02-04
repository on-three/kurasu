
ifndef EP
$(error episode number is not defined. e.g. EP=02)
endif

NAME := Thinking.Crow.s01e$(EP)
OUT_DIR := ./out/$(NAME)
SUBS_DIR := ./subs
DATA_DIR := ./data
VIDEO_DIR := ./video
TS := $(VIDEO_DIR)/$(NAME).ts
MKV := $(OUT_DIR)/$(NAME).mkv
SRT_EN := $(SUBS_DIR)/$(NAME).en_us.srt
SRT_JP := $(SUBS_DIR)/$(NAME).ja_jp.srt
ASS_EN := $(SUBS_DIR)/$(NAME).en_us.ass

# input m3u8 file (from nhke site) must be named appropriately after download
M3U8 := $(DATA_DIR)/ep$(EP).m3u8

# input ttml subs (from nhke site) must be named appropriately after download
TTML := $(DATA_DIR)/ep$(EP).ttml


# tools
FFMPEG := ffmpeg
TTML2SRT := /home/on-three/code/ttml/ttml/convert.py
MIXTAPE := uploadtomixtape.sh

all: $(SRT_JP) $(MKV)

$(OUT_DIR):
	mkdir -p $@

#$(TS): $(M3U8)
#	$(FFMPEG) -i $(M3U8) -c copy $@

$(MKV): $(TS) $(SRT_JP) $(ASS_EN)
	$(FFMPEG) -i $(TS) -i $(ASS_EN) -i $(SRT_JP) \
	-map 0:v -map 0:a -map 1 -map 2 \
	-metadata:s:s:0 language=eng -metadata:s:s:1 language=jpn $@

$(SRT_JP): $(TTML)
	$(TTML2SRT) $^ -o $@

mixtape: $(MKV)
	# upload to mixtape.moe to share
	$(MIXTAPE) $^

