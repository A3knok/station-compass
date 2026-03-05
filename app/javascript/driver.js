import { driver } from "driver.js";

export function setUpDriver() {
  const isGuest = document.body.dataset.isGuest === 'true'

  const driverObj = driver({
    animate: true,
    showProgress: true,
    overlayOpacity: 0.5,
    showButtons: true,
    prevBtnText: "戻る",
    nextBtnText: "次へ"
  });

  // ゲストユーザーの場合は3ステップ
  if(isGuest) {
    driverObj.setSteps([
      {
        element: "#step1",
        popover: {
          title: "出発地・目的地で検索",
          description: "出発改札と目的出口をセットして検索してください",
          showButtons: ["next"],
          side: "top",
          align: "start"
        }
      },
      {
        element: "#step2",
        popover: {
          title: "カテゴリーとタグ検索",
          description: "必要に応じてカテゴリー、タグも入れて検索してください",
          showButtons: ["previous", "next"]
        }
      },
      {
        element: "#step3",
        popover: {
          title: "検索結果",
          description: "条件に合ったルートが表示されます。検索条件がない場合はすべてのルートが表示されます。",
          showButtons: ["previous", "close"]
        }
      }
    ]);
  } else {
    // 一般ユーザーの場合は4ステップ
    driverObj.setSteps([
      {
        element: "#step1",
        popover: {
          title: "出発地・目的地検索",
          description: "出発改札と目的出口をセットして検索してください",
          showButtons: ["next"],
          side: "top",
          align: "start"
        }
      },
      {
        element: "#step2",
        popover: {
          title: "カテゴリーとタグ検索",
          description: "必要に応じてカテゴリー、タグも入れて検索してください",
          showButtons: ["previous", "next"]
        }
      },
      {
        element: "#step3",
        popover: {
          title: "検索結果",
          description: "条件に合ったルートが表示されます。検索条件がない場合はすべてのルートが表示されます。",
          showButtons: ["previous", "next"]
        }
      },
      {
        element: "#step4",
        popover: {
          title: "ルート投稿",
          description: "あなたの知っているルートを投稿して駅迷子ユーザーを助けましょう",
          showButtons: ["previous", "close"]
        }
      }
    ]);
  }

  driverObj.drive();
}