package asciicast2

import (
	"bytes"
	"encoding/json"
	"pigs/pkg/utils"
)

type CastV2Header struct {
	Version      uint               `json:"version"`
	Width        int                `json:"width"`
	Height       int                `json:"height"`
	Timestamp    int64              `json:"timestamp,omitempty"`
	Duration     float64            `json:"duration,omitempty"`
	Title        string             `json:"title,omitempty"`
	Command      string             `json:"command,omitempty"`
	Env          *map[string]string `json:"env,omitempty"`
	outputStream *json.Encoder
}

func NewCastV2(meta CastV2Header, stream *bytes.Buffer) (*CastV2Header, *bytes.Buffer) {
	var c CastV2Header
	c.Version = 2
	//c.Width = meta.Width
	//c.Height = meta.Height
	// 固定宽高用于前端展示
	c.Width = meta.Width
	c.Height = meta.Height
	c.Title = meta.Title
	c.Timestamp = meta.Timestamp
	c.Duration = c.Duration
	c.Env = meta.Env
	c.outputStream = json.NewEncoder(stream)
	c.outputStream.Encode(c)
	return &c, stream
}

func (c *CastV2Header) Record(t float64, data []byte, event string) {
	out := make([]interface{}, 3)
	//timeNow := time.Since(t).Seconds()
	out[0] = t
	out[1] = event // i：input；o：output
	out[2] = utils.Bytes2Str(data)
	c.Duration = t
	c.outputStream.Encode(out)
}
