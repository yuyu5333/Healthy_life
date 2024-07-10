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

import { BadgeCard } from './BadgeCardComponent'
import { getAchievementLevel } from '../model/AchieveModel'
import { getBadgeCardItems } from '../viewmodel/AchievementViewModel'
import Logger from '../common/utils/Logger'
import { ACHIEVEMENT_LEVEL_KEY } from '../model/AchieveModel'
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import CardInfo from '../viewmodel/CardInfo'

//
import TaskInfo from '../viewmodel/TaskInfo';
import { ratio2percent } from '../common/utils/Utils'
import { TaskMapById,AchievementMap } from '../model/TaskInitList';
///
//
@Component
export struct BadgePanel {
  @StorageProp(ACHIEVEMENT_LEVEL_KEY) successiveDays: number = 0;
  @Prop myTasks: TaskInfo[];

  aboutToAppear() {
    Logger.debug('BadgePanel', 'aboutToAppear');
    getAchievementLevel();
  }

  build() {
    Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
      ForEach(getBadgeCardItems(this.successiveDays), (item: CardInfo) => {
        BadgeCard({ content: item.titleContent, imgSrc: item.achievement })
      })

      Row() {
        Text('每日任务')
          .fontSize($r('app.float.default_24'))
          .fontColor($r('app.color.white'))
          .align(Alignment.Start)
          .padding({ left: Const.ACHIEVE_TITLE_BAR_LEFT, top: Const.ACHIEVE_TITLE_BAR_TOP })
      }
      .width(Const.FULL_WIDTH)

      this.SingleTasksSuccess(this.myTasks)

      Row() {
        Text('到底啦')
          .fontSize($r('app.float.default_24'))
          .fontColor($r('app.color.white'))
          .align(Alignment.Start)
          .padding({ left: Const.ACHIEVE_TITLE_BAR_LEFT, top: Const.ACHIEVE_TITLE_BAR_TOP })
      }
      .width(Const.FULL_WIDTH)

    }
    .width(Const.FULL_WIDTH)
  }

  @Builder
  SingleTasksSuccess(tasks: TaskInfo[]) {
    ForEach(tasks, (task: TaskInfo) => {
      ForEach([1,2,3,4],(taskSuccessTimes:number)=>{
        if(TaskMapById[task.taskID-1].step===0){
          if(taskSuccessTimes===1){
            Column({ space: Const.DEFAULT_18 }) {
              Image(getTaskIcon(task,taskSuccessTimes))
                .width(Const.FULL_WIDTH)
                .height(Const.ACHIEVE_CARD_IMG_HEIGHT)
                .objectFit(ImageFit.Contain)
              Text(`${AchievementMap.task_name[task.taskID-1]}`)
                .lineHeight($r('app.float.default_16'))
                .fontSize($r('app.float.default_12'))
                .fontColor($r('app.color.white'))
            }
            .width(ratio2percent(Const.ACHIEVE_SPLIT_RATIO))
            .padding({ top: Const.ACHIEVE_CARD_TOP, bottom: Const.ACHIEVE_CARD_BOTTOM })
          }
        }else{
          Column({ space: Const.DEFAULT_18 }) {
            Image(getTaskIcon(task,taskSuccessTimes))
              .width(Const.FULL_WIDTH)
              .height(Const.ACHIEVE_CARD_IMG_HEIGHT)
              .objectFit(ImageFit.Contain)
            Text(`${AchievementMap.task_name[task.taskID-1]}${taskSuccessTimes}周目`)
              .lineHeight($r('app.float.default_16'))
              .fontSize($r('app.float.default_12'))
              .fontColor($r('app.color.white'))
          }
          .width(ratio2percent(Const.ACHIEVE_SPLIT_RATIO))
          .padding({ top: Const.ACHIEVE_CARD_TOP, bottom: Const.ACHIEVE_CARD_BOTTOM })
        }

      })
    })
  }
}

function getTaskIcon(task:TaskInfo, times: number) : Resource {
  let result = $r('app.string.empty');
  let taskItem = TaskMapById[task.taskID-1];
  if(times===1){
    if(task.isDone){
      result = geticonResoure(task.taskID,true);
    }else {
      result = geticonResoure(task.taskID,false);
    }
  }else{
    if(Number(task.finValue)/Number(task.targetValue) >=times){
      result = geticonResoure(task.taskID,true);
    }else{
      result = geticonResoure(task.taskID,false);
    }
  }
  return result;
}

function geticonResoure(taskid:number, isSuccess:boolean): Resource {
  let result = $r('app.string.empty');
  if(isSuccess){
    switch (taskid) {
      case 1:
        result = AchievementMap.success_task1;
        break;
      case 2:
        result = AchievementMap.success_task2;
        break;
      case 3:
        result = AchievementMap.success_task3;
        break;
      case 4:
        result = AchievementMap.success_task4;
        break;
      case 5:
        result = AchievementMap.success_task5;
        break;
      case 6:
        result = AchievementMap.success_task6;
        break;
      case 7:
        result = AchievementMap.success_task7;
        break;
      default:
        break;
    }
  }else{
    switch (taskid) {
      case 1:
        result = AchievementMap.undo_task1;
        break;
      case 2:
        result = AchievementMap.undo_task2;
        break;
      case 3:
        result = AchievementMap.undo_task3;
        break;
      case 4:
        result = AchievementMap.undo_task4;
        break;
      case 5:
        result = AchievementMap.undo_task5;
        break;
      case 6:
        result = AchievementMap.undo_task6;
        break;
      case 7:
        result = AchievementMap.undo_task7;
        break;
      default:
        break;
    }
  }
  return result;
}