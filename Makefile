
ifndef EP
$(error EP is not defined. e.g. EP=02)
endif

NAME := Thinking.Crow.s01e$(EP)
DIR := ./$(NAME)
TS := $(DIR)/$(NAME).ts
MKV := $(DIR)/$(NAME).mkv
SRT_EN := $(DIR)/$(NAME).en_us.srt
SRT_JP := $(DIR)/$(NAME).ja_jp.srt
ASS_EN := $(DIR)/$(NAME).en_us.ass

# input m3u8 file (from nhke site)
M3U8 := $(DIR)/master.m3u8

# input ttml subs (from nhke site)
TTML := $(DIR)/master.m3u8.ttml


# tools
FFMPEG := ffmpeg
TTML2SRT := /home/on-three/code/ttml/ttml/convert.py


all: $(DIR) $(TTML) $(M3U8) $(MKV)

$(DIR):
	mkdir $@

$(TS): $(M3U8)
	$(FFMPEG) -i $^ -c copy $@

$(MKV): $(TS) $(SRT_JP) $(ASS_EN)
	# TODO:

$(SRT_JP): $(TTML)
	$(TTML2SRT) $^ -o $@


