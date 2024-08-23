import { Router } from "express";
import StockController from "../controllers/stock.js";

const router = Router()

router.get('/entre', async(req,res) => {
    await StockController.addStock(req,res)
})

router.get('/sortie', (req,res) =>{
    console.log('sortie')
})

export default router