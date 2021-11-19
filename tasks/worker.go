package tasks

import (
	"context"
	"pigs/common"
	"time"

	"log"
	"os"
	"os/signal"

	"github.com/hibiken/asynq"
	"golang.org/x/sys/unix"
)

// loggingMiddleware 记录任务日志中间件
func loggingMiddleware(h asynq.Handler) asynq.Handler {
	return asynq.HandlerFunc(func(ctx context.Context, t *asynq.Task) error {
		start := time.Now()
		log.Printf("Start processing %q", t.Type())
		err := h.ProcessTask(ctx, t)
		if err != nil {
			return err
		}
		log.Printf("Finished processing %q: Elapsed Time = %v", t.Type(), time.Since(start))
		return nil
	})
}

func TaskWorker() {
	config := common.CONFIG
	srv := asynq.NewServer(
		asynq.RedisClientOpt{
			Addr:     config.Redis.Host,
			Username: config.Redis.UserName,
			Password: config.Redis.PassWord,
			DB:       config.Redis.DB,
		},
		asynq.Config{Concurrency: 20},
	)

	mux := asynq.NewServeMux()
	mux.Use(loggingMiddleware)
	//
	mux.HandleFunc(SyncAliYunCloud, HandleAliCloudTask)

	// start server
	if err := srv.Start(mux); err != nil {
		log.Fatalf("could not start server: %v", err)
	}

	// Wait for termination signal.
	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, unix.SIGTERM, unix.SIGINT, unix.SIGTSTP)
	for {
		s := <-sigs
		if s == unix.SIGTSTP {
			srv.Shutdown()
			continue
		}
		break
	}

	// Stop worker server.
	srv.Stop()
}
