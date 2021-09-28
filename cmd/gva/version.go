package gva

import (
	"github.com/gookit/color"

	"github.com/spf13/cobra"
)

// versionCmd represents the version command
var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "版本信息",
	Long:  `版本的长信息`,
	Run: func(cmd *cobra.Command, args []string) {
		color.Green.Println("v3.0.0")
	},
}

func init() {
	rootCmd.AddCommand(versionCmd)
}
