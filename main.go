package main

import (
	l "git.scc.kit.edu/lukasburgey/wattsPluginLib"
	"github.com/kalaspuffar/base64url"
	"encoding/json"
	"bytes"
)

func request(input l.Input) l.Output {
	userid, _ := base64url.Decode(input.WaTTSUserID)
	credential := make([]l.Credential, len(input.UserInfo) + 4)

	credential[0] = l.TextCredential("WaTTS version", input.WaTTSVersion)
	credential[1] = l.TextCredential("WaTTS userid", input.WaTTSUserID)
	credential[2] =	l.TextCredential("WaTTS userid (decoded)", string(userid))

	userInfo := input.UserInfo
	i := 3
	for key, value := range userInfo {
		name := oidc_key_to_name(key)
		encType := oidc_key_to_type(key)
		credential[i] =l.Credential{
			"type":  encType,
			"name":  name,
			"value": value,
		}
		i++
	}

	JsonOutput := nice_json(input)
	credential[i] = l.Credential{
		"type":  "textfile",
		"name":  "json object",
		"value": JsonOutput,
		"rows": 20,
		"cols": 50,
		"save_as": "info.json",
	}
	return l.PluginGoodRequest(credential, "user_info")
}


func nice_json(i interface{}) string {
	result := ""
	b := new(bytes.Buffer)

	indentation := ""
	outputTabWidth := "    "
	encoder := json.NewEncoder(b)
	encoder.SetEscapeHTML(false)
	encoder.SetIndent(indentation, outputTabWidth)

	err := encoder.Encode(i)
	if err == nil {
		outputBytes := b.Bytes()
		result = string(outputBytes)
	}
	return result
}

func oidc_key_to_name(key string) string {
	if key == "iss" {
		return "Issuer"
	}
	if key == "sub" {
		return "Subject"
	}
	if key == "name" {
		return "Name"
	}
	if key == "groups" {
		return "Groups"
	}
	if key == "email" {
		return "E-Mail"
	}
	if key == "gender" {
		return "Gender"
	}
	return key
}

func oidc_key_to_type(key string) string {
	if key == "groups" {
		return "textarea"
	}
	return "text"
}



func revoke(pi l.Input) l.Output {
	return l.PluginGoodRevoke()
}

func main() {
	pluginDescriptor := l.PluginDescriptor{
		Version:     "1.0.0",
		Author:      "Bas Wegh @ KIT",
		Name:        "wattsInfoPlugin",
		Description: "watts info plugin",
		Actions: map[string]l.Action{
			"request": request,
			"revoke":  revoke},
		ConfigParams:  []l.ConfigParamsDescriptor{},
		RequestParams: []l.RequestParamsDescriptor{},
	}
	l.PluginRun(pluginDescriptor)
}
