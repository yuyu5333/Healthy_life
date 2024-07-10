/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CommonConstants as Const } from '../../common/constants/CommonConstants';
import { AchievementMap, TaskMapById } from '../../model/TaskInitList';
import TaskInfo from '../../viewmodel/TaskInfo';

const ANGLE_LARGE = 360;

//修改了部分显示逻辑，使得可以显示singletask完成
@CustomDialog
export struct AchievementDialog {
  controller: CustomDialogController = new CustomDialogController({ builder: 0 });
  @Consume achievementLevel: number;
  @Consume isAchievement: number;
  @Consume singleTask:TaskInfo;
  @State private opacityValue: number = 0;
  @State private angle: number = 0;
  @State private scaleValue: number = 0;
  @State achievementMapValue: Resource = $r('app.string.empty');

  getSuccessStatement(taskID:number) : string{
    let result: string;
    result =AchievementMap.statement_task_success[taskID-1];
    return result;
  }

  getSuccessStatement2(taskID:number) : string{
    let result: string;
    result ="";

    if(TaskMapById[taskID-1].step !== 0){
      let task_success_times = Math.floor(Number(this.singleTask.finValue)/Number(this.singleTask.targetValue));
      if(task_success_times ==1){
        result = result + `\n任务完成啦！！！`;
      }else{
        result = result + `\你竟然把这个任务完成了${task_success_times}遍！！！不可思议！！！`;
      }
    }

    return result;
  }

  aboutToAppear() {
    if(this.isAchievement ===1){
      switch (this.achievementLevel) {
        case 3:
          this.achievementMapValue = AchievementMap.on_3;
          break;
        case 7:
          this.achievementMapValue = AchievementMap.on_7;
          break;
        case 30:
          this.achievementMapValue = AchievementMap.on_30;
          break;
        case 50:
          this.achievementMapValue = AchievementMap.on_50;
          break;
        case 73:
          this.achievementMapValue = AchievementMap.on_73;
          break;
        case 99:
          this.achievementMapValue = AchievementMap.on_99;
          break;
        default:
          break;
      }
    }
    if(this.isAchievement ===0){
      switch (this.achievementLevel) {
        case 1:
          this.achievementMapValue = AchievementMap.success_task1;
          break;
        case 2:
          this.achievementMapValue = AchievementMap.success_task2;
          break;
        case 3:
          this.achievementMapValue = AchievementMap.success_task3;
          break;
        case 4:
          this.achievementMapValue = AchievementMap.success_task4;
          break;
        case 5:
          this.achievementMapValue = AchievementMap.success_task5;
          break;
        case 6:
          this.achievementMapValue = AchievementMap.success_task6;
          break;
        case 7:
          this.achievementMapValue = AchievementMap.success_task7;
          break;
        default:
          break;
      }
    }
  }

  build() {
    Column() {

      Image(this.achievementMapValue)
        .width(Const.THOUSANDTH_560)
        .height(Const.THOUSANDTH_400)
        .objectFit(ImageFit.Contain)

      Text(this.isAchievement ===1?
      $r('app.string.task_achievement_level', this.achievementLevel):
      this.getSuccessStatement(this.achievementLevel))
        .fontSize($r('app.float.default_24'))
        .fontWeight(Const.FONT_WEIGHT_500)
        .fontColor($r('app.color.white'))
        .fontFamily($r('app.string.HarmonyHeiTi'))
        .margin({ top: $r('app.float.default_12') })

      if(this.isAchievement ===0){
        Text(this.getSuccessStatement2(this.achievementLevel))
          .fontSize($r('app.float.default_24'))
          .fontWeight(Const.FONT_WEIGHT_500)
          .fontColor($r('app.color.white'))
          .fontFamily($r('app.string.HarmonyHeiTi'))
          .margin({ top: $r('app.float.default_12') })
      }

    }
    .height(Const.THOUSANDTH_800)
    .width(Const.THOUSANDTH_1000)
    .justifyContent(FlexAlign.Center)
    .gesture(TapGesture().onAction(() => {
      this.controller.close();
    }))
    .scale({ x: this.scaleValue, y: this.scaleValue })
    .rotate({ x: 0, y: 1, z: 0, angle: this.angle })
    .opacity(this.opacityValue)
    .onAppear(() => {
      animateTo({
        duration: Const.DURATION_800,
        curve: Curve.EaseOut,
        delay: Const.DURATION_100,
        iterations: 1
      }, () => {
        this.opacityValue = 1;
        this.scaleValue = 1;
        this.angle = ANGLE_LARGE;
      });
    })
  }
}



